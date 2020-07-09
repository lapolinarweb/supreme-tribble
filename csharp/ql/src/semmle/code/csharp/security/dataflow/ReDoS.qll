/**
 * Provides a taint-tracking configuration for reasoning about untrusted user input used in dangerous
 * regular expression operations.
 */
import csharp

module ReDoS {
  import semmle.code.csharp.dataflow.flowsources.Remote
  import semmle.code.csharp.frameworks.system.text.RegularExpressions
  import semmle.code.csharp.security.Sanitizers

  /**
   * A data flow source for untrusted user input used in dangerous regular expression operations.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for untrusted user input used in dangerous regular expression operations.
   */
  abstract class Sink extends DataFlow::ExprNode { }

  /**
   * A sanitizer for untrusted user input used in dangerous regular expression operations.
   */
  abstract class Sanitizer extends DataFlow::ExprNode { }

  /**
   * A taint-tracking configuration for untrusted user input used in dangerous regular expression operations.
   */
  class TaintTrackingConfiguration extends TaintTracking::Configuration {
    TaintTrackingConfiguration() {
      this = "ReDoS"
    }

    override
    predicate isSource(DataFlow::Node source) {
      source instanceof Source
    }

    override
    predicate isSink(DataFlow::Node sink) {
      sink instanceof Sink
      or
      // Unfortunately, we cannot add `ExponentialRegexSink` as
      // a sub class of `Sink`, as that results in bad aggregate
      // recursion. Therefore, we overestimate the sinks here
      // and make the restriction later by overriding
      // `hasFlow()` below.
      sink.asExpr() = any(RegexOperation ro).getInput()
    }

    override
    predicate isSanitizer(DataFlow::Node node) {
      node instanceof Sanitizer
    }

    override predicate hasFlow(DataFlow::Node source, DataFlow::Node sink) {
      super.hasFlow(source, sink) and
      (sink instanceof Sink or sink instanceof ExponentialRegexSink)
    }
  }

  /** A source of remote user input. */
  class RemoteSource extends Source {
    RemoteSource() {
      this instanceof RemoteFlowSource
    }
  }

  /**
   * An expression that represents a regular expression with potential exponential behavior.
   */
  predicate isExponentialRegex(StringLiteral s) {
    /*
     * Detect three variants of a common pattern that leads to exponential blow-up.
     */
    // Example: ([a-z]+.)+
    s.getValue().regexpMatch(".*\\([^()*+\\]]+\\]?(\\*|\\+)\\.?\\)(\\*|\\+).*") or
    // Example: (([a-z])?([a-z]+.))+
    s.getValue().regexpMatch(".*\\((\\([^()]+\\)\\?)?\\([^()*+\\]]+\\]?(\\*|\\+)\\.?\\)\\)(\\*|\\+).*") or
    // Example: (([a-z])+.)+
    s.getValue().regexpMatch(".*\\(\\([^()*+\\]]+\\]?\\)(\\*|\\+)\\.?\\)(\\*|\\+).*")
  }

  /**
   * A data flow configuration for tracking exponential worst case time regular expression string
   * literals to the pattern argument of a regex.
   */
  class ExponentialRegexDataflow extends DataFlow::Configuration {
    ExponentialRegexDataflow() {
      this = "ExponentialRegex"
    }

    override
    predicate isSource(DataFlow::Node s) {
      isExponentialRegex(s.asExpr())
    }

    override
    predicate isSink(DataFlow::Node s) {
      s.asExpr() = any(RegexOperation c).getPattern()
    }
  }

  /**
   * An expression passed as the `input` to a call to a `Regex` method, where the regex appears to
   * have exponential behaviour.
   */
  class ExponentialRegexSink extends DataFlow::ExprNode {
    ExponentialRegexSink() {
      exists(ExponentialRegexDataflow regexDataflow, RegexOperation regexOperation |
        // Exponential regex flows to the pattern argument
        regexDataflow.hasFlow(_, DataFlow::exprNode(regexOperation.getPattern())) |
        // This is used as an input for this pattern
        this.getExpr() = regexOperation.getInput() and
        // No timeouts
        not regexOperation.hasTimeout()
      )
    }
  }

  private class SimpleTypeSanitizer extends Sanitizer, SimpleTypeSanitizedExpr { }

  private class GuidSanitizer extends Sanitizer, GuidSanitizedExpr { }
}
