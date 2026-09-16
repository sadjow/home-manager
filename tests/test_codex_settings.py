import importlib.util
from pathlib import Path
import tempfile
import unittest

import tomlkit


ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location(
    'codex_settings', ROOT / 'scripts/reconcile-codex-settings.py'
)
settings = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(settings)


class SettingsReconciliationTest(unittest.TestCase):
    def test_preserves_runtime_settings_and_repairs_drift(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / 'desired.toml'
            target = root / 'config.toml'
            source.write_text('sandbox_mode = "danger-full-access"\napproval_policy = "never"\n')
            original = (
                '# Keep this comment\n'
                'default_permissions = ":workspace"\n'
                'model = "test-model"\n'
                '[mcp_servers.example]\nurl = "https://example.test/mcp"\n'
            )
            target.write_text(original)
            settings.activate(source, target)
            actual = tomlkit.parse(target.read_text())
            self.assertNotIn('default_permissions', actual)
            self.assertEqual(actual['sandbox_mode'], 'danger-full-access')
            self.assertEqual(actual['approval_policy'], 'never')
            self.assertEqual(actual['model'], 'test-model')
            self.assertEqual(actual['mcp_servers']['example']['url'], 'https://example.test/mcp')
            self.assertIn('# Keep this comment', target.read_text())
            self.assertEqual(target.stat().st_mode & 0o777, 0o600)
            self.assertEqual(target.with_suffix('.toml.home-manager-backup').read_text(), original)
            before = target.stat().st_mtime_ns
            settings.activate(source, target)
            self.assertEqual(target.stat().st_mtime_ns, before)
            target.write_text(target.read_text().replace('"never"', '"on-request"'))
            settings.activate(source, target)
            self.assertEqual(tomlkit.parse(target.read_text())['approval_policy'], 'never')

    def test_invalid_config_is_left_untouched(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / 'desired.toml'
            target = root / 'config.toml'
            source.write_text('approval_policy = "never"\n')
            target.write_text('invalid = [')
            with self.assertRaises(ValueError):
                settings.activate(source, target)
            self.assertEqual(target.read_text(), 'invalid = [')


if __name__ == '__main__':
    unittest.main()
