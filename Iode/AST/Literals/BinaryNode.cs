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

        public Expression left { get; set; }
        public char op { get; set; }
        public Expression right { get; set; }

        private string _value { get; set; }

        public override dynamic value
        {
            get
            {
                return _value;
            }
        }

        public BinaryNode(Expression left, char op, Expression right)
        {
            this.left = left;
            this.op = op;
            this.right = right;

            if (left.type == NodeType.STRING && right.type == NodeType.STRING)
            {
                StringNode leftStr = (StringNode)left;
                StringNode rightStr = (StringNode)right;
                this._value = leftStr.value + rightStr.value;
            }
        }

        public override void generate(ILGenerator ilg)
        {
            if (left.type == NodeType.NUMBER && right.type == NodeType.NUMBER)
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
            else if (left.type == NodeType.STRING && right.type == NodeType.STRING)
            {
                ilg.Emit(OpCodes.Ldstr, _value);
            }
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
