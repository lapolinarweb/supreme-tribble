package com.semmle.js.ast;

/**
 * An import specifier such as <code>x</code> and <code>y as z</code> in <code>
 * import { x, y as z } from 'foo';</code>.
 *
 * <p>An import specifier has a local name and an imported name; for instance, <code>y as z</code>
 * has local name <code>z</code> and imported name <code>y</code>, while <code>x</code> has both
 * local and imported name <code>x</code>.
 */
public class ImportSpecifier extends Expression {
  private final Identifier imported, local;

  public ImportSpecifier(SourceLocation loc, Identifier imported, Identifier local) {
    this("ImportSpecifier", loc, imported, local);
  }

  public ImportSpecifier(String type, SourceLocation loc, Identifier imported, Identifier local) {
    super(type, loc);
    this.imported = imported;
    this.local = local == imported ? new NodeCopier().copy(local) : local;
  }

  public Identifier getImported() {
    return imported;
  }

  public Identifier getLocal() {
    return local;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
