let project = new Project('Kat');
project.addAssets('Assets/*');
project.addAssets("Assets/locale/*", { notinlist: true, destination: "data/locale/{name}" });
project.addSources('Sources');

project.addLibrary('Libraries/zui');
resolve(project);
