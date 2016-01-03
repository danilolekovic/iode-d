using System;
using System.Reflection.Emit;

namespace Iode.AST
{
    /// <summary>
    /// Represents a binary operation (l +|-|/|* r) in the AST
    /// </summary>
    public class BinaryNode : Expression
    {
        public override NodeType type
        {
            get
            {
                return NodeType.BINARY;
            }
        }

        public Node left { get; set; }
        public char op { get; set; }
        public Node right { get; set; }

        public BinaryNode(Node left, char op, Node right)
        {
            this.left = left;
            this.op = op;
            this.right = right;
        }

        public override void generate(ILGenerator ilg)
        {
            left.generate(ilg);

            switch (op)
            {
                case '+':
                    ilg.Emit(OpCodes.Add);
                    break;
                case '-':
                    ilg.Emit(OpCodes.Sub);
                    break;
                case '*':
                    ilg.Emit(OpCodes.Mul);
                    break;
                case '/':
                    ilg.Emit(OpCodes.Div);
                    break;
            }

            right.generate(ilg);
        }

        public override string ToString()
        {
            return op.ToString();
        }

        public int getPrecedence(char op)
        {
            switch (op)
            {
                case '+':
                case '*':
                    return 100;
                case '-':
                case '/':
                    return 99;
                default:
                    return 0;
            }
        }
    }
}
