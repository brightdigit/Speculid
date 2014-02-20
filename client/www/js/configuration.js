define(['json!../../../tmp/build', 'json!../../../package.json'], function(buildUTC, package) {
  return {
    build: buildUTC,
    package: package
  };
});
