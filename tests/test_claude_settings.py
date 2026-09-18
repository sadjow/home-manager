import json
import os
from pathlib import Path
import runpy
import subprocess
import tempfile
import unittest


class ClaudeSettingsActivationTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        expression = '''let
          flake = builtins.getFlake (toString ./.);
          config = flake.homeConfigurations.sadjow.config;
        in {
          linked = builtins.any (name: builtins.hasAttr name config.home.file)
            [ ".claude/settings.json" ".claude/settings.local.json" ];
          activation = config.home.activation.claudeWritableSettings.data or "";
        }'''
        cls.config = json.loads(subprocess.check_output(
            ['nix', 'eval', '--impure', '--json', '--expr', expression], text=True
        ))

    def test_settings_are_writable_and_preferences_survive_activation(self):
        with tempfile.TemporaryDirectory() as directory:
            home = Path(directory)
            target = home / '.claude/settings.json'
            target.parent.mkdir()
            source = home / 'store-settings.json'
            source.write_text('{"model":"original"}')
            source.chmod(0o444)
            target.symlink_to(source)
            activation = self.config['activation']
            subprocess.run(['bash', '-eu', '-c', 'run() { "$@"; }\n' + activation],
                           env={**os.environ, 'HOME': str(home)}, check=True)
            self.assertFalse(target.is_symlink(), 'settings still point to a read-only store file')
            self.assertFalse(self.config['linked'], 'Home Manager still owns a settings symlink')
            self.assertEqual(target.stat().st_mode & 0o777, 0o600)
            local = target.with_name('settings.local.json')
            self.assertFalse(local.is_symlink())
            self.assertEqual(local.stat().st_mode & 0o777, 0o600)
            settings = json.loads(target.read_text())
            settings['model'] = 'session-choice'
            target.write_text(json.dumps(settings))
            subprocess.run(['bash', '-eu', '-c', 'run() { "$@"; }\n' + activation],
                           env={**os.environ, 'HOME': str(home)}, check=True)
            self.assertEqual(json.loads(target.read_text())['model'], 'session-choice')
            self.assertEqual(source.read_text(), '{"model":"original"}')


class SettingsReconciliationTest(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        root = Path(self.temporary.name)
        self.source = root / 'source.json'
        self.target = root / 'runtime/settings.json'
        self.baseline = root / 'baseline/settings.json'
        self.activate = runpy.run_path('scripts/reconcile-claude-settings.py')['activate']
        self.defaults = {'model': 'default', 'permissions': {'allow': ['Read'], 'old': True}}
        self.source.write_text(json.dumps(self.defaults))

    def apply(self):
        self.activate(self.source, self.target, self.baseline)
        return json.loads(self.target.read_text())

    def test_updates_preserve_unrelated_preferences_and_remove_retired_settings(self):
        self.apply()
        current = json.loads(self.target.read_text())
        current.update(model='chosen', runtimeOnly=True)
        current['permissions']['runtime'] = True
        self.target.write_text(json.dumps(current))
        self.source.write_text(json.dumps({
            'model': 'default', 'permissions': {'allow': ['Read', 'Write']}
        }))
        expected = {'model': 'chosen', 'runtimeOnly': True,
                    'permissions': {'allow': ['Read', 'Write'], 'runtime': True}}
        self.assertEqual(self.apply(), expected)
        self.assertEqual(self.apply(), expected)
        self.assertEqual(json.loads(self.target.with_name(
            'settings.json.home-manager-backup').read_text()), current)
        self.source.write_text('{"model":"new-default"}')
        self.assertEqual(self.apply(), {'model': 'new-default', 'runtimeOnly': True})

    def test_missing_runtime_is_restored_and_read_only_mode_is_repaired(self):
        self.apply()
        self.target.unlink()
        self.assertEqual(self.apply(), self.defaults)
        self.target.chmod(0o400)
        self.apply()
        self.assertEqual(self.target.stat().st_mode & 0o777, 0o600)

    def test_invalid_runtime_leaves_runtime_and_baseline_untouched(self):
        self.apply()
        baseline = self.baseline.read_bytes()
        self.target.write_text('{invalid')
        with self.assertRaises(ValueError):
            self.apply()
        self.assertEqual(self.target.read_text(), '{invalid')
        self.assertEqual(self.baseline.read_bytes(), baseline)


if __name__ == '__main__':
    unittest.main()
