using Iode.AST;
using System;

namespace Iode.Analysis.Types
{
    public class TypeChecker
    {
        /// <summary>
        /// Attempts to compute the type of the specified node
        /// </summary>
        /// <param name="value">The node</param>
        /// <returns>Type</returns>
        public static Type getType(Node value)
        {
            if (value.type == NodeType.VARIABLE)
            {
                double dbl = 0;
                VariableNode vn = (VariableNode)value;
                bool bl = false;

                if (bool.TryParse(value.ToString(), out bl))
                {
                    return typeof(bool);
                }
                else if (vn.variableType == NodeType.STRING)
                {
                    return typeof(string);
                }
                else if (double.TryParse(value.ToString(), out dbl) || value.type == NodeType.BINARY)
                {
                    return typeof(int);
                }
                else
                {
                    return null;
                }
            }
            else if (value.type == NodeType.NUMBER || value.type == NodeType.BINARY)
            {
                return typeof(int);
            }
            else if (value.type == NodeType.STRING)
            {
                return typeof(string);
            }
            else if (value.type == NodeType.BOOLEAN)
            {
                return typeof(bool);
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// Checks if the specified value is a [type]
        /// </summary>
        /// <param name="value">Node to be compared</param>
        /// <param name="type">Type compared to</param>
        /// <returns>Boolean</returns>
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
            else if (type == typeof(Type))
            {
                return true;
            }
            else
            {
                return false;
            }
        }
    }
}
