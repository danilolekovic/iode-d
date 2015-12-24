using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Iode.Analysis.Lexical
{
    public class Token
    {
        public TokenType type { get; set; }
        public string value { get; set; }

        public Token(TokenType type, string value)
        {
            this.type = type;
            this.value = value;
        }

        public TokenType getType()
        {
            return this.type;
        }

        public string getValue()
        {
            return this.value;
        }
    }
}
