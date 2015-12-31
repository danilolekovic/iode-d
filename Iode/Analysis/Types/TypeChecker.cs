using Iode.AST;
using System;

namespace Iode.Analysis.Types
{
    public class TypeChecker
    {
        public static bool sameType(Node value, Type type)
        {
            if (type == typeof(int))
            {
                if (value.type == NodeType.VARIABLE)
                {
                    double dbl = 0;

                    if (!double.TryParse(value.ToString(), out dbl))
                    {
                        return false;
                    }

                    return true;
                }
                else if (value.type == NodeType.NUMBER)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            else if (type == typeof(string))
            {
                if (value.type == NodeType.VARIABLE)
                {
                    VariableNode vn = (VariableNode)value;

                    if (vn.variableType != NodeType.STRING)
                    {
                        return false;
                    }

                    return true;
                }
                else if (value.type == NodeType.STRING)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            else if (type == typeof(bool))
            {
                if (value.type == NodeType.VARIABLE)
                {
                    bool bl = false;

                    if (!bool.TryParse(value.ToString(), out bl))
                    {
                        return false;
                    }
                    
                    return true;
                }
                else if (value.type == NodeType.BOOLEAN)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            else
            {
                return false;
            }
        }
    }
}
