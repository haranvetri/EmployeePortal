using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.NetworkInformation;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static EmployeePortal.Repository;

namespace EmployeePortal
{
    public partial class EmployeeForm : System.Web.UI.Page
    {
        DbConnection db = new DbConnection();
        private static List<Employee> allEmployees = new List<Employee>(); // set this once from DB

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                 allEmployees = db.GetAllEmployees();
                gvEmployees.DataSource = allEmployees;
                gvEmployees.DataBind();
            }
           
        }


        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            string searchTerm = txtSearch.Text.Trim().ToLower();

            var filtered = allEmployees.Where(emp =>
                emp.Name.ToLower().Contains(searchTerm) ||
                emp.Designation.ToLower().Contains(searchTerm) ||
                emp.Gender.ToLower().Contains(searchTerm) ||
                emp.State.ToLower().Contains(searchTerm)).ToList();

            gvEmployees.DataSource = filtered;
            gvEmployees.DataBind();
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            try
            {
                btnSubmit.Visible = true;
                btnUpdate.Visible = false;
                var emp = new Employee
                {
                    Name = txtName.Text.Trim(),
                    DOB = Convert.ToDateTime(txtDOB.Text),
                    Age = Convert.ToInt32(txtAge.Text),
                    Designation = txtDesignation.Text.Trim(),
                    DOJ = Convert.ToDateTime(txtDOJ.Text),
                    Salary = Convert.ToDecimal(txtSalary.Text),
                    Gender = ddlGender.SelectedValue,
                    State = ddlState.SelectedValue
                };

                // Insert record
                db.InsertEmployee(emp);

                // Refresh grid data
                gvEmployees.DataSource = db.GetAllEmployees();
                gvEmployees.DataBind();

                // ✅ Manually update the grid's UpdatePanel
                updGridPanel.Update();

                // Clear input fields
                ClearForm();
               


                ScriptManager.RegisterStartupScript(this, this.GetType(), "HideModal", @"
    var modalEl = document.getElementById('employeeModal');
    var modal = bootstrap.Modal.getInstance(modalEl);
    if (modal) {
        modal.hide();
    }
    document.body.classList.remove('modal-open');
    document.querySelectorAll('.modal-backdrop').forEach(el => el.remove());
", true);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Error", $"alert('Error: {ex.Message}');", true);
            }
        }


        private void ClearForm()
        {
            txtName.Text = string.Empty;
            txtDOB.Text = string.Empty;
            txtAge.Text = string.Empty;
            txtDesignation.Text = string.Empty;
            txtDOJ.Text = string.Empty;
            txtSalary.Text = string.Empty;
            ddlGender.SelectedIndex = 0;
            ddlState.SelectedIndex = 0;
        }

        protected void txtDOB_TextChanged(object sender, EventArgs e)
        {
            if (DateTime.TryParse(txtDOB.Text, out DateTime dob))
            {
                int age = DateTime.Today.Year - dob.Year;
                if (dob > DateTime.Today.AddYears(-age)) age--;

                txtAge.Text = age.ToString();
            }
            else
            {
                txtAge.Text = string.Empty;
            }
            //            ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", @"
            //    var modal = new bootstrap.Modal(document.getElementById('employeeModal'), {
            //        backdrop: 'static',
            //        keyboard: false
            //    });
            //    modal.show();
            //", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "$('#employeeModal').modal('show');", true);


        }
        protected void lnkDelete_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lnk = (LinkButton)sender;
                int employeeId = Convert.ToInt32(lnk.CommandArgument);

                // Call the DB method to delete
                db.DeleteEmployeeById(employeeId);

                // Rebind updated data
                gvEmployees.DataSource = db.GetAllEmployees();
                gvEmployees.DataBind();

                // Update the Grid UpdatePanel
                updGridPanel.Update();

                // Optional: show success message
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Success", "alert('Employee deleted successfully!');", true);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Error", $"alert('Error deleting employee: {ex.Message}');", true);
            }
        }

        protected void lnkEdit_Click(object sender, EventArgs e)
        {
            LinkButton lnk = (LinkButton)sender;
            GridViewRow row = (GridViewRow)lnk.NamingContainer;

            // Fill fields
            txtName.Text = ((Label)row.FindControl("lblName")).Text;
            txtDOB.Text = ((Label)row.FindControl("lblDOB")).Text;
            txtAge.Text = ((Label)row.FindControl("lblAge")).Text;
            txtDesignation.Text = ((Label)row.FindControl("lblDesignation")).Text;
            txtDOJ.Text = ((Label)row.FindControl("lblDOJ")).Text;
            txtSalary.Text = ((Label)row.FindControl("lblSalary")).Text;
            ddlGender.SelectedValue = ((Label)row.FindControl("lblGender")).Text;
            ddlState.SelectedValue = ((Label)row.FindControl("lblState")).Text;
            hdnEmployeeId.Value = lnk.CommandArgument;
            // Show update button, hide submit
            btnSubmit.Visible = false;
            btnUpdate.Visible = true;

            // Trigger modal show via flag
            hdnShowModal.Value = "true";
        }



        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (int.TryParse(hdnEmployeeId.Value, out int empId))
            {
                Employee emp = new Employee
                {
                    Id = empId,
                    Name = txtName.Text.Trim(),
                    DOB = DateTime.Parse(txtDOB.Text),  
                    Age = int.Parse(txtAge.Text),
                    Designation = txtDesignation.Text.Trim(),
                    DOJ = DateTime.Parse(txtDOJ.Text),
                    Salary = decimal.Parse(txtSalary.Text),
                    Gender = ddlGender.SelectedValue,
                    State = ddlState.SelectedValue
                };

                // Call separate method to update
                db.UpdateEmployeeInDB(emp);

                // Refresh grid and close modal
                gvEmployees.DataSource = db.GetAllEmployees();
                gvEmployees.DataBind();
                updGridPanel.Update();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "HideModal", "$('#employeeModal').modal('hide');", true);
            }
        }

        protected void gvEmployees_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvEmployees.PageIndex = e.NewPageIndex;
            gvEmployees.DataSource = db.GetAllEmployees(); // rebind data
            gvEmployees.DataBind();
        }


        protected void gvEmployees_RowDataBound(object sender, GridViewRowEventArgs e)
        {

        }
    }
}