/**
 * @name Uncontrolled data used in path expression
 * @description Accessing paths influenced by users can allow an attacker to access unexpected resources.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/path-injection
 * @tags security
 *       external/cwe/cwe-022
 *       external/cwe/cwe-023
 *       external/cwe/cwe-036
 *       external/cwe/cwe-073
 */
import java
import semmle.code.java.dataflow.FlowSources
import PathsCommon

class TaintedPathConfig extends TaintTracking::Configuration {
  TaintedPathConfig() { this = "TaintedPathConfig" }
  override predicate isSource(DataFlow::Node source) { source instanceof RemoteUserInput }
  override predicate isSink(DataFlow::Node sink) {
    exists(Expr e | e = sink.asExpr() | e = any(PathCreation p).getInput() and not guarded(e))
  }
  override predicate isSanitizer(DataFlow::Node node) {
    exists(Type t | t = node.getType() | t instanceof BoxedType or t instanceof PrimitiveType)
  }
}

from RemoteUserInput u, PathCreation p, Expr e, TaintedPathConfig conf
where
  e = p.getInput() and
  conf.hasFlow(u, DataFlow::exprNode(e))
select p, "$@ flows to here and is used in a path.", u, "User-provided value"
