import javascript

query predicate test_getId(Function f, VarDecl res0, string res1) {
  res0 = f.getId() and res1 = f.getName()
}
