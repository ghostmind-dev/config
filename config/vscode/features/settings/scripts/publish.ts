import type { CustomArgs, CustomOptions } from 'jsr:@ghostmind/run';
import { $ } from 'npm:zx@8.1.3';

export default async function (args: CustomArgs, opts: CustomOptions) {
  $.verbose = true;

  const { currentPath } = opts;
  const registry = 'ghcr.io';
  const namespace = 'ghostmind-dev/config';

  // Get the feature name from arguments (optional)

  // Get all feature directories

  const feature = 'settings';

  const featurePath = `${currentPath}/config/vscode/features/settings/src`;

  const featureConfigPath = `${featurePath}/devcontainer-feature.json`;

  const featureConfigText = await Deno.readTextFile(featureConfigPath);
  const featureConfig = JSON.parse(featureConfigText);
  const version = featureConfig.version;
  const name = featureConfig.name;

  console.log(`   📋 ${name} v${version}`);
  console.log(`   Target: ${registry}/${namespace}/settings:${version}`);

  // Publish with version tag
  await $`devcontainer features publish ${featurePath} --registry ${registry} --namespace ${namespace}`;

  console.log(`✅ Successfully published ${feature}:${version}`);
  console.log(`   📖 Usage: "${registry}/${namespace}/settings:${version}"`);

  console.log('\n🎉 All features published successfully!');
  console.log(
    `\n🔗 Registry: https://github.com/ghostmind-dev/config/pkgs/container/feature`
  );
}
