let project = new Project('Kat');
project.addAssets('Assets/*');
project.addAssets("Assets/locale/*", { notinlist: true, destination: "data/locale/{name}" });
project.addAssets("keymap_presets/*", { notinlist: true, destination: "data/keymap_presets/{name}" });
project.addSources('Sources');

// @TODO: Fix strict null safety issues by enabling this and fixing the compile issues
// project.addParameter('--macro nullSafety("kat", Strict)');

project.addLibrary('Libraries/zui');
resolve(project);
