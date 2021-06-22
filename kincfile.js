let project = new Project('Kat');

project.addFile('Sources/**');
project.setDebugDir('Deployment');

resolve(project);
