import semmle.code.csharp.Conversion

from Type sub, Type sup, string s1, string s2
where convConversionOperator(sub, sup)
  and sub != sup
  and s1 = sub.toString()
  and s2 = sup.toString()
  /* Remove certain results to make the test output consistent
   * between different versions of .NET Core. */
  and s2 != "FormatParam"
  and s2 != "StringOrCharArray"
select s1, s2
order by s1, s2
