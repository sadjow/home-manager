import importlib.util
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch


ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location('daemon', ROOT / 'scripts/reconcile-codex-daemon.py')
daemon = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(daemon)


class DaemonReconciliationTest(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.home = Path(self.directory.name)
        self.settings = self.home / 'app-server-daemon/settings.json'
        self.settings.parent.mkdir()
        self.settings.write_text(json.dumps({
            'featureOverrides': {'api_key_model_discovery': False},
            'remoteControlEnabled': True,
        }))
        self.calls = []
        self.running = True
        self.version = '0.161.0'

    def codex(self, executable, *args):
        self.calls.append(args)
        if args == ('features', 'list'):
            return 'api_key_model_discovery stable true\n'
        if args[-1] == 'version':
            return json.dumps({'cliVersion': '0.161.0', 'appServerVersion': self.version,
                               'status': 'running' if self.running else 'notRunning'})
        if args[-1] == 'stop':
            self.running = False
        if args[-1] == 'start':
            settings = json.loads(self.settings.read_text())
            settings.pop('featureOverrides', None)
            self.settings.write_text(json.dumps(settings))
            self.running = True
        return '{}'

    def test_fresh_start_clears_stale_override_that_restart_preserves(self):
        with patch.object(daemon, 'run', self.codex):
            self.assertEqual(daemon.reconcile('codex', self.home, restart=True), 0)
        self.assertNotIn('featureOverrides', json.loads(self.settings.read_text()))
        self.assertTrue(json.loads(self.settings.read_text())['remoteControlEnabled'])

    def test_check_reports_drift_without_mutation(self):
        original = self.settings.read_bytes()
        with patch.object(daemon, 'run', self.codex):
            self.assertEqual(daemon.reconcile('codex', self.home), 1)
        self.assertEqual(self.settings.read_bytes(), original)
        self.assertFalse(any(call[-1] in ('stop', 'start', 'restart') for call in self.calls))

    def test_stop_failure_does_not_start_or_edit_settings(self):
        original = self.settings.read_bytes()
        def fail_stop(executable, *args):
            if args[-1] == 'stop':
                raise RuntimeError('Stop failed')
            return self.codex(executable, *args)
        with patch.object(daemon, 'run', fail_stop):
            with self.assertRaisesRegex(RuntimeError, 'Stop failed'):
                daemon.reconcile('codex', self.home, restart=True)
        self.assertEqual(self.settings.read_bytes(), original)
        self.assertNotIn(('app-server', 'daemon', 'start'), self.calls)

    def test_start_failure_is_reported(self):
        def fail_start(executable, *args):
            if args[-1] == 'start':
                raise RuntimeError('Start failed')
            return self.codex(executable, *args)
        with patch.object(daemon, 'run', fail_start):
            with self.assertRaisesRegex(RuntimeError, 'Start failed'):
                daemon.reconcile('codex', self.home, restart=True)
        self.assertFalse(self.running)

    def test_explicit_restart_does_not_skip_when_saved_settings_match(self):
        self.settings.write_text('{}')
        with patch.object(daemon, 'run', self.codex):
            self.assertEqual(daemon.reconcile('codex', self.home, restart=True), 0)
        self.assertIn(('app-server', 'daemon', 'stop'), self.calls)

    def test_unknown_feature_fails_before_stopping(self):
        self.settings.write_text('{"featureOverrides":{"unknown":true}}')
        with patch.object(daemon, 'run', self.codex):
            with self.assertRaises(ValueError):
                daemon.reconcile('codex', self.home, restart=True)
        self.assertNotIn(('app-server', 'daemon', 'stop'), self.calls)


if __name__ == '__main__':
    unittest.main()
