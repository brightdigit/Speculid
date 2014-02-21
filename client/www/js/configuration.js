define(['json!../../../tmp/build', 'json!../../../package.json', 'text!../../../tmp/stage'], function(buildUTC, package, stage) {
  return {
    build: buildUTC,
    package: package,
    stage: stage
  };
});
