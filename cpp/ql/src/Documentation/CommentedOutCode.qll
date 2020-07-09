import cpp

/**
 * Holds if `line` looks like a line of code.
 * Matches comment lines ending with '{', '}' or ';' that do not start with '>' or contain '@{' or '@}', but first filters out:
 *  * HTML entities in common notation (e.g. &amp;gt; and &amp;eacute;)
 *  * HTML entities in decimal notation (e.g. a&amp;#768;)
 *  * HTML entities in hexadecimal notation (e.g. &amp;#x705F;)
 * To account for the code generated by protobuf, we also insist that the comment
 * does not begin with `optional` or `repeated` and end with a `;`, which would
 * normally be a quoted bit of literal `.proto` specification above the associated
 * declaration.
 * To account for emacs folding markers, we ignore any line containing
 * `{{{` or `}}}`.
 *
 * Finally, some code tends to embed GUIDs in comments, so we also exclude those.
 */
bindingset[line]
private predicate looksLikeCode(string line) {
    exists(string trimmed |
           trimmed = line.regexpReplaceAll("(?i)(^\\s+|&#?[a-z0-9]{1,31};|\\s+$)", "") |
           trimmed.regexpMatch(".*[{};]")
           and not trimmed.regexpMatch("(>.*|.*[\\\\@][{}].*|(optional|repeated) .*;|.*(\\{\\{\\{|\\}\\}\\}).*|\\{[-0-9a-zA-Z]+\\})"))
}

/**
 * The line of a C++-style comment within its file `f`.
 */
private int lineInFile(CppStyleComment c, File f) {
    f = c.getFile() and
    result = c.getLocation().getStartLine()
}

/**
 * The "comment block ID" for a comment line in a file.
 * The block ID is obtained by subtracting the line rank of the line from
 * the line itself, where the line rank is the (1-based) rank within `f`
 * of lines containing a C++-style comment. As a result, line comments on
 * consecutive lines are assigned the same block ID (as both line number
 * and line rank increase by 1 for each line), while intervening lines
 * without line comments would increase the line number without increasing
 * the rank and thus force a change of block ID.
 */
private pragma[nomagic] int commentLineBlockID(File f, int line) {
    exists(int lineRank |
        line = rank[lineRank](lineInFile(_, f)) and
        result = line - lineRank
    )
}

/**
 * The comment ID of the given comment (on line `line` of file `f`).
 * The resulting number is meaningless, except that it will be the same
 * for all comments in a run of consecutive comment lines, and different
 * for separate runs.
 */
private int commentId(CppStyleComment c, File f, int line) {
    result = commentLineBlockID(f, line) and
    line = lineInFile(c, f)
}

/**
 * A contiguous block of comments.
 */
class CommentBlock extends Comment {
    CommentBlock() {
        this instanceof CppStyleComment implies
        not exists(CppStyleComment pred, File f | lineInFile(pred, f) + 1 = lineInFile(this, f))
    }

    /**
     * Gets the `i`th comment associated with this comment block.
     */
    Comment getComment(int i) {
        (i = 0 and result = this) or
        exists(File f, int thisLine, int resultLine |
            commentId(this, f, thisLine) = commentId(result, f, resultLine) |
            i = resultLine - thisLine
        )
    }

    Comment lastComment() {
        result = this.getComment(max(int i | exists(this.getComment(i))))
    }

    string getLine(int i) {
        this instanceof CStyleComment and result = this.getContents().regexpCapture("(?s)/\\*+(.*)\\*+/", 1).splitAt("\n", i)
        or
        this instanceof CppStyleComment and result = this.getComment(i).getContents().suffix(2)
    }

    int numLines() {
        result = strictcount(int i, string line | line = this.getLine(i) and line.trim() != "")
    }

    int numCodeLines() {
        result = strictcount(int i, string line | line = this.getLine(i) and looksLikeCode(line))
    }

    predicate isDocumentation() {
        // If a C-style comment starts each line with a *, then it's
        // probably documentation rather than code.
        this instanceof CStyleComment and
        forex(int i | i in [1 .. this.numLines() - 1]
                    | this.getLine(i).trim().matches("*%"))
    }

    predicate isCommentedOutCode() {
        not this.isDocumentation() and
        this.numCodeLines().(float) / this.numLines().(float) > 0.5
    }

    /**
     * Holds if this element is at the specified location.
     * The location spans column `startcolumn` of line `startline` to
     * column `endcolumn` of line `endline` in file `filepath`.
     * For more information, see
     * [LGTM locations](https://lgtm.com/help/ql/locations).
     */
    predicate hasLocationInfo(string filepath, int startline, int startcolumn, int endline, int endcolumn) {
        this.getLocation().hasLocationInfo(filepath, startline, startcolumn, _, _) and
        this.lastComment().getLocation().hasLocationInfo(_, _, _, endline, endcolumn)
    }
}

/**
 * A piece of commented-out code, identified using heuristics
 */
class CommentedOutCode extends CommentBlock {
    CommentedOutCode() {
        this.isCommentedOutCode()
    }
}

