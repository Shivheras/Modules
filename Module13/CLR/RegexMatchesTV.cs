using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.SqlServer.Server;
using System.Text.RegularExpressions;
using System.Collections;
using System.Data.SqlTypes;

namespace CLR
{
    class RegexMatchesTV
    {
 
        [SqlFunction(Name = "RegexMatches", FillRowMethodName = "FillRow", TableDefinition = "match nvarchar(500)")]
        public static IEnumerable InitMethod(string text, string pattern)
        {
            List<string> list = new List<string>();

            if (!string.IsNullOrEmpty(text) && !string.IsNullOrEmpty(pattern))
            {
                foreach (Match match in Regex.Matches(text, pattern))
                {
                    list.Add(match.Value);
                }
            }

            return list;
        }

        public static void FillRow(object obj, out SqlString match)
        {
            match = (string)obj;
        }
    }
}
