const Registry = artifacts.require("Registry");

contract('Registry', () => {
  let registryInstance;
  let storage;
  const testName = "test_package_name";
  const testPath = "test_package_path";

  before(async() => {
    registryInstance = await Registry.deployed();
    storage = await registryInstance.storage();
    assert.equal(storage, {}, "Registry was not initialized empty.");
  });

  it("...should register a Package.", async() => {
    await registryInstance.register(testName, testPath);
    storage = await registryInstance.storage();
    console.log(storage)
    assert.equal(storage, {[testName]: testPath}, "package was not registered");
  });

  it("...should deregister a Package.", async() => {
    await registryInstance.deregister(testName);
    storage = await registryInstance.storage();
    assert.equal(storage, {}, "package was not deregistered");
  });
});
