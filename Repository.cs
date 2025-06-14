using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EmployeePortal
{
    public class Repository
    {
        public class Employee
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public DateTime DOB { get; set; }
            public int Age { get; set; }
            public string Designation { get; set; }
            public DateTime DOJ { get; set; }
            public decimal Salary { get; set; }
            public string Gender { get; set; }
            public string State { get; set; }
        }

    }
}