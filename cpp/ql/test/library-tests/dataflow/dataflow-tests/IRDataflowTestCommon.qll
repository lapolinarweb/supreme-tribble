import cpp
import semmle.code.cpp.ir.dataflow.DataFlow

/** Common data flow configuration to be used by tests. */
class TestAllocationConfig extends DataFlow::Configuration {
  TestAllocationConfig() { this = "TestAllocationConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().(FunctionCall).getTarget().getName() = "source"
    or
    source.asParameter().getName().matches("source%")
    or
    // Track uninitialized variables
    exists(source.asUninitialized())
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall call |
      call.getTarget().getName() = "sink" and
      sink.asExpr() = call.getAnArgument()
    )
  }

  override predicate isBarrier(DataFlow::Node barrier) {
    barrier.asExpr().(VariableAccess).getTarget().hasName("barrier")
  }
}
