﻿using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis;
using Semmle.Extraction.Entities;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    class LocalFunction : Statement<LocalFunctionStatementSyntax>
    {
        LocalFunction(Context cx, LocalFunctionStatementSyntax node, IStatementParentEntity parent, int child)
            : base(cx, node, StmtKind.LOCAL_FUNCTION, parent, child, cx.Create(node.GetLocation())) { }

        public static LocalFunction Create(Context cx, LocalFunctionStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new LocalFunction(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        /// <summary>
        /// Gets the IMethodSymbol for this local function statement.
        /// </summary>
        IMethodSymbol Symbol
        {
            get
            {
                // Ideally model.GetDeclaredSymbol(Stmt) would do
                // the right thing but it doesn't exist.
                // So instead, we have to do the lookup via GetEnclosingSymbol.

                var m = cx.Model(Stmt);
                var body = Stmt.Body == null ? Stmt.ExpressionBody : (CSharpSyntaxNode)Stmt.Body;
                return m.GetEnclosingSymbol(body.GetLocation().SourceSpan.Start) as IMethodSymbol;
            }
        }

        /// <summary>
        /// Gets the function defined by this local statement.
        /// </summary>
        Entities.LocalFunction Function => Entities.LocalFunction.Create(cx, Symbol);

        protected override void Populate()
        {
            cx.Emit(Tuples.local_function_stmts(this, Function));
        }
    }
}
