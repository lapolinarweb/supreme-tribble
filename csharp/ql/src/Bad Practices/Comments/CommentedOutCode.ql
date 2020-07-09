/**
 * @name Commented-out code
 * @description Comments that contain commented-out code should be avoided.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id cs/commented-out-code
 * @tags maintainability
 *       statistical
 *       non-attributable
 */

import csharp

class CommentedOutCode extends CommentBlock
{
  CommentedOutCode()
  {
    not isXmlCommentBlock() and
    2*count(getAProbableCodeLine()) > count(getANonEmptyLine())
  }
}

from CommentedOutCode comment
select comment, "This comment appears to contain commented-out code."
