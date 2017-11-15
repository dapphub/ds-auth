dapp: with dapp; solidityPackage {
  name = "ds-auth";
  deps = with dappsys; [ds-test];
  src = ./src;
}
