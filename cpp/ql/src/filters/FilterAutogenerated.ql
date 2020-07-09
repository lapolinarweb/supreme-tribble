/**
 * @name Filter: exclude results from files that are autogenerated
 * @description Use this filter to return results only if they are
 *              located in files that are maintained manually.
 * @kind problem
 * @id cpp/autogenerated-filter
 */
 
import cpp
import semmle.code.cpp.AutogeneratedFile
import external.DefectFilter

from DefectResult res
where not res.getFile() instanceof AutogeneratedFile
select res,
       res.getMessage()
