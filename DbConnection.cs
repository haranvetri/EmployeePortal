using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.Odbc;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using static EmployeePortal.Repository;

namespace EmployeePortal
{
    public class DbConnection
    {
        static string sServer = ConfigurationManager.AppSettings["Server"];
        static string sDBUser = ConfigurationManager.AppSettings["DBUser"];
        static string sDBPwd = ConfigurationManager.AppSettings["DBPwd"];
        static string sDBName = ConfigurationManager.AppSettings["SQLDBName"];


        string sConstr = "Data Source=" + sServer + ";Initial Catalog=" + sDBName + ";User ID=" + sDBUser + ";Password=" + sDBPwd;
        public static long lretcode;
        SqlConnection sqlCon;
        SqlConnection sqlSAPCon;
        SqlCommand cmd;
        SqlDataAdapter sa;
        DataTable dtlog;
        DataSet dslog;
        OdbcConnection oCon;

        public List<Employee> GetAllEmployees()
        {
            var employeeList = new List<Employee>();

            try
            {
                
                using (SqlConnection conn = new SqlConnection(sConstr))
                {
                    conn.Open();
                    string query = "SELECT * FROM Employees";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            var emp = new Employee
                            {
                                Id = Convert.ToInt32(reader["EmployeeID"]),
                                Name = reader["Name"].ToString(),
                                DOB = Convert.ToDateTime(reader["DOB"]),
                                Age = Convert.ToInt32(reader["Age"]),
                                Designation = reader["Designation"].ToString(),
                                DOJ = Convert.ToDateTime(reader["DOJ"]),
                                Salary = Convert.ToDecimal(reader["Salary"]),
                                Gender = reader["Gender"].ToString(),
                                State = reader["State"].ToString()
                            };

                            employeeList.Add(emp);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Log or handle exception as needed
                throw new Exception("Error retrieving employees", ex);
            }

            return employeeList;
        }

        public void InsertEmployee(Employee emp)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(sConstr))
                {
                    conn.Open();
                    string query = @"INSERT INTO Employees 
                            (Name, DOB, Age, Designation, DOJ, Salary, Gender, State)
                             VALUES 
                            (@Name, @DOB, @Age, @Designation, @DOJ, @Salary, @Gender, @State)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Name", emp.Name);
                        cmd.Parameters.AddWithValue("@DOB", emp.DOB);
                        cmd.Parameters.AddWithValue("@Age", emp.Age);
                        cmd.Parameters.AddWithValue("@Designation", emp.Designation);
                        cmd.Parameters.AddWithValue("@DOJ", emp.DOJ);
                        cmd.Parameters.AddWithValue("@Salary", emp.Salary);
                        cmd.Parameters.AddWithValue("@Gender", emp.Gender);
                        cmd.Parameters.AddWithValue("@State", emp.State);

                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error inserting employee", ex);
            }
        }

        public void DeleteEmployeeById(int employeeId)
        {
            
            using (SqlConnection conn = new SqlConnection(sConstr))
            {
                SqlCommand cmd = new SqlCommand("DELETE FROM Employees WHERE EmployeeId = @Id", conn);
                cmd.Parameters.AddWithValue("@Id", employeeId);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }
        public void UpdateEmployeeInDB(Employee emp)
        {
            using (SqlConnection conn = new SqlConnection(sConstr))
            {
                string query = @"UPDATE Employees
                         SET Name = @Name, DOB = @DOB, Age = @Age, Designation = @Designation,
                             DOJ = @DOJ, Salary = @Salary, Gender = @Gender, State = @State
                         WHERE EmployeeID = @EmployeeID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@EmployeeID", emp.Id);
                    cmd.Parameters.AddWithValue("@Name", emp.Name);
                    cmd.Parameters.AddWithValue("@DOB", emp.DOB);
                    cmd.Parameters.AddWithValue("@Age", emp.Age);
                    cmd.Parameters.AddWithValue("@Designation", emp.Designation);
                    cmd.Parameters.AddWithValue("@DOJ", emp.DOJ);
                    cmd.Parameters.AddWithValue("@Salary", emp.Salary);
                    cmd.Parameters.AddWithValue("@Gender", emp.Gender);
                    cmd.Parameters.AddWithValue("@State", emp.State);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

    }
}