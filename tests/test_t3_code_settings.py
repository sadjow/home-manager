import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest


def run_activation(activation, home):
    subprocess.run(['bash', '-eu', '-c', 'run() { "$@"; }\n' + activation],
                   env={**os.environ, 'HOME': str(home)}, check=True)


class T3CodeSettingsActivationTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        # Building the fixture realises the generated settings file the
        # activation script references, which a plain evaluation leaves unbuilt.
        expression = '''let
          flake = builtins.getFlake (toString ./.);
          config = flake.homeConfigurations.sadjow.config;
        in flake.inputs.nixpkgs.legacyPackages.aarch64-darwin.writeText
          "t3-code-test-fixture.json" (builtins.toJSON {
            codexProfiles = import ./home/codex/profiles.nix;
            activation = config.home.activation.t3CodeSettings.data;
          })'''
        fixture = subprocess.check_output(
            ['nix', 'build', '--impure', '--no-link', '--print-out-paths', '--expr', expression],
            text=True,
        ).strip()
        cls.config = json.loads(Path(fixture).read_text())

    def test_declared_providers_merge_into_the_writable_runtime_file(self):
        with tempfile.TemporaryDirectory() as directory:
            home = Path(directory)
            target = home / '.t3/userdata/settings.json'
            target.parent.mkdir(parents=True)
            runtime = {
                'providerInstances': {
                    'claudeAgent': {
                        'driver': 'claudeAgent',
                        'enabled': False,
                        'config': {'binaryPath': 'claude', 'customModels': ['chosen-model']},
                    },
                },
            }
            target.write_text(json.dumps(runtime))
            run_activation(self.config['activation'], home)
            settings = json.loads(target.read_text())
            instances = settings['providerInstances']
            self.assertEqual(target.stat().st_mode & 0o777, 0o600)
            self.assertTrue(instances['claudeAgent']['enabled'])
            self.assertEqual(instances['claudeAgent']['config']['customModels'], ['chosen-model'])
            spireworks_home = self.config['codexProfiles']['isolated']['codex-spireworks']
            self.assertEqual(instances['codex_spireworks']['config'],
                             {'binaryPath': 'codex-spireworks', 'homePath': f'~/{spireworks_home}'})
            self.assertFalse(settings['providers']['grok']['enabled'])
            self.assertEqual(instances['cursor_spireworks']['displayName'],
                             instances['codex_spireworks']['displayName'])
            self.assertEqual(instances['cursor_durst']['driver'], 'cursor')
            self.assertEqual(instances['claude_stackbuilders']['config'],
                             {'binaryPath': 'claude-stackbuilders', 'homePath': '~/.claude-stackbuilders'})
            self.assertEqual(instances['claude_spireworks']['config'],
                             {'binaryPath': 'claude-spireworks', 'homePath': '~/.claude-spireworks'})
            self.assertEqual(instances['claude_spireworks']['displayName'],
                             instances['codex_spireworks']['displayName'])

            instances['claudeAgent']['config']['launchArgs'] = '--verbose'
            target.write_text(json.dumps(settings))
            run_activation(self.config['activation'], home)
            self.assertEqual(json.loads(target.read_text())['providerInstances']['claudeAgent']
                             ['config']['launchArgs'], '--verbose')


if __name__ == '__main__':
    unittest.main()
