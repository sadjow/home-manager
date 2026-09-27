from pathlib import Path
import subprocess
import tempfile
import unittest


KEY = 'claudeCode.allowDangerouslySkipPermissions'


class JsoncSettingTest(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.settings = Path(self.temporary.name) / 'User/settings.json'
        self.backup = self.settings.with_name('settings.json.home-manager-backup')

    def enable(self):
        return subprocess.run(
            ['node', 'scripts/set-jsonc-setting.js', str(self.settings), KEY, 'true'],
            capture_output=True, text=True,
        )

    def write(self, text):
        self.settings.parent.mkdir(parents=True, exist_ok=True)
        self.settings.write_text(text)
        self.settings.chmod(0o644)

    def test_adds_setting_while_keeping_comments_and_trailing_commas(self):
        self.write('{\n  // keep me\n  "a": {\n    "b": 1,\n  },\n  "c": 2,\n}\n')
        self.assertEqual(self.enable().returncode, 0)
        self.assertEqual(self.settings.read_text(),
                         '{\n  // keep me\n  "a": {\n    "b": 1,\n  },\n  "c": 2,\n'
                         f'  "{KEY}": true,\n}}\n')
        self.assertEqual(self.backup.read_text(),
                         '{\n  // keep me\n  "a": {\n    "b": 1,\n  },\n  "c": 2,\n}\n')
        self.assertEqual(self.settings.stat().st_mode & 0o777, 0o644)

    def test_replaces_a_disabled_setting(self):
        self.write(f'{{\n  "{KEY}": false,\n  "c": 2\n}}\n')
        self.assertEqual(self.enable().returncode, 0)
        self.assertEqual(self.settings.read_text(), f'{{\n  "{KEY}": true,\n  "c": 2\n}}\n')

    def test_leaves_an_enabled_setting_untouched(self):
        original = f'{{\n  "c": 2,\n  "{KEY}": true,\n}}\n'
        self.write(original)
        self.assertEqual(self.enable().returncode, 0)
        self.assertEqual(self.settings.read_text(), original)
        self.assertFalse(self.backup.exists())

    def test_creates_missing_settings(self):
        self.assertEqual(self.enable().returncode, 0)
        self.assertEqual(self.settings.read_text(), f'{{\n  "{KEY}": true\n}}\n')

    def test_invalid_settings_fail_without_changes(self):
        self.write('{ "c": ')
        result = self.enable()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('invalid JSONC', result.stderr)
        self.assertEqual(self.settings.read_text(), '{ "c": ')
        self.assertFalse(self.backup.exists())


if __name__ == '__main__':
    unittest.main()
