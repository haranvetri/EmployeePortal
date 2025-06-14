<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EmployeeForm.aspx.cs" Inherits="EmployeePortal.EmployeeForm" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hdnShowModal" runat="server" Value="false" />


    <div class="container mt-4">

        <!-- 🔎 Search and ➕ Add Icon -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="mb-0">Employee List</h4>

            <div class="d-flex">
                <asp:TextBox ID="txtSearch" runat="server" AutoPostBack="true" CssClass="form-control me-2" AutoComplete="off"
                    OnTextChanged="txtSearch_TextChanged" placeholder="Search..." />
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#employeeModal" onclick="clearEmployeeForm()">
                    <i class="bi bi-plus"></i>
                </button>
               
            </div>
        </div>

        <asp:UpdatePanel ID="updGridPanel" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <asp:HiddenField ID="hdnEmployeeId" runat="server" />
                <asp:GridView ID="gvEmployees" runat="server" AutoGenerateColumns="false"
                    CssClass="table table-bordered table-striped table-hover"
                    AllowPaging="true" PagerStyle-CssClass="gv-pager"
                    PageSize="5"
                    OnPageIndexChanging="gvEmployees_PageIndexChanging"
                    OnRowDataBound="gvEmployees_RowDataBound">
                    <Columns>
                        <asp:TemplateField HeaderStyle-Width="50px">
                            <HeaderTemplate>
                                <input type="checkbox" id="chkHeader" onclick="toggleAllCheckboxes(this)" />
                            </HeaderTemplate>
                            <ItemTemplate>
                                <input type="checkbox" class="chkRow" />
                            </ItemTemplate>
                        </asp:TemplateField>


                        <asp:TemplateField HeaderText="Name">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkEdit" runat="server"
                                    Text='<%# Eval("Name") %>'
                                    CommandArgument='<%# Eval("Id") %>'
                                    OnClick="lnkEdit_Click"
                                    CssClass="btn btn-link p-0"></asp:LinkButton>
                                <asp:Label ID="lblName" runat="server" Text='<%# Eval("Name") %>' Visible="false" />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Date of Birth">
                            <ItemTemplate>
                                <asp:Label ID="lblDOB" runat="server" Text='<%# Eval("DOB", "{0:yyyy-MM-dd}") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Age">
                            <ItemTemplate>
                                <asp:Label ID="lblAge" runat="server" Text='<%# Eval("Age") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Designation">
                            <ItemTemplate>
                                <asp:Label ID="lblDesignation" runat="server" Text='<%# Eval("Designation") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Date of Join">
                            <ItemTemplate>
                                <asp:Label ID="lblDOJ" runat="server" Text='<%# Eval("DOJ", "{0:yyyy-MM-dd}") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Salary">
                            <ItemTemplate>
                                <asp:Label ID="lblSalary" runat="server" Text='<%# Eval("Salary") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Gender">
                            <ItemTemplate>
                                <asp:Label ID="lblGender" runat="server" Text='<%# Eval("Gender") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="State">
                            <ItemTemplate>
                                <asp:Label ID="lblState" runat="server" Text='<%# Eval("State") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkDelete" runat="server"
                                    CommandArgument='<%# Eval("Id") %>'
                                    OnClick="lnkDelete_Click"
                                    OnClientClick='<%# "return confirm(\"Are you sure you want to delete this employee " + Eval("Name") + "?\");" %>'
                                    CssClass="btn btn-sm btn-danger" ToolTip="Delete">
                            <i class="bi bi-trash"></i>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>
            </ContentTemplate>
        </asp:UpdatePanel>


    </div>

    <!-- 🪟 Bootstrap Modal inside UpdatePanel -->
    <asp:UpdatePanel ID="updModalPanel" runat="server" UpdateMode="Conditional">
        <ContentTemplate>

            <div class="modal fade" id="employeeModal" tabindex="-1" aria-labelledby="employeeModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header bg-primary text-white">
                            <h5 class="modal-title" id="employeeModalLabel">Employee Registration</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <asp:Panel ID="pnlForm" runat="server" CssClass="form-horizontal">
                                <div class="row mb-3">
                                    <div class="col-md-4">
                                        <label class="form-label">Name</label>
                                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control" AutoComplete="off" />
                                        <asp:RequiredFieldValidator ID="rfvName" runat="server"
                                            ControlToValidate="txtName"
                                            ErrorMessage="Name is required"
                                            CssClass="text-danger"
                                            Display="Dynamic"
                                            ValidationGroup="EmpForm" />
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label">Date of Birth</label>
                                        <asp:TextBox ID="txtDOB" runat="server" TextMode="Date" AutoPostBack="true" CssClass="form-control"
                                            OnTextChanged="txtDOB_TextChanged" />
                                        <asp:RequiredFieldValidator ID="rfvDOB" runat="server" ControlToValidate="txtDOB"
                                            ErrorMessage="DOB is required" CssClass="text-danger" Display="Dynamic" ValidationGroup="EmpForm" />
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label">Age</label>
                                        <asp:TextBox ID="txtAge" runat="server" CssClass="form-control" ReadOnly="true" />
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-4">
                                        <label class="form-label">Designation</label>
                                        <asp:TextBox ID="txtDesignation" runat="server" CssClass="form-control" AutoComplete="off" />
                                        <asp:RequiredFieldValidator ID="rfvDesignation" runat="server" ControlToValidate="txtDesignation"
                                            ErrorMessage="Designation is required" CssClass="text-danger" Display="Dynamic" ValidationGroup="EmpForm" />
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label">Date of Join</label>
                                        <asp:TextBox ID="txtDOJ" runat="server" TextMode="Date" CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="rfvDOJ" runat="server" ControlToValidate="txtDOJ"
                                            ErrorMessage="Date of Join is required" CssClass="text-danger" Display="Dynamic" ValidationGroup="EmpForm" />
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label">Salary</label>
                                        <asp:TextBox ID="txtSalary" runat="server" CssClass="form-control" AutoComplete="off" />
                                        <asp:RequiredFieldValidator ID="rfvSalary" runat="server" ControlToValidate="txtSalary"
                                            ErrorMessage="Salary is required" CssClass="text-danger" Display="Dynamic" ValidationGroup="EmpForm" />
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-4">
                                        <label class="form-label">Gender</label>
                                        <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-select">
                                            <asp:ListItem Text="Male" />
                                            <asp:ListItem Text="Female" />
                                            <asp:ListItem Text="Other" />
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="rfvGender" runat="server" ControlToValidate="ddlGender"
                                            InitialValue="" ErrorMessage="Gender is required" CssClass="text-danger" Display="Dynamic" ValidationGroup="EmpForm" />
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label">State</label>
                                        <asp:DropDownList ID="ddlState" runat="server" CssClass="form-select">
                                            <asp:ListItem Text="-- Select State --" Value="" />
                                            <asp:ListItem Text="Kerala" Value="Kerala" />
                                            <asp:ListItem Text="Tamil Nadu" Value="Tamil Nadu" />
                                            <asp:ListItem Text="Karnataka" Value="Karnataka" />
                                            <asp:ListItem Text="Andhra Pradesh" Value="Andhra Pradesh" />
                                            <asp:ListItem Text="Telangana" Value="Telangana" />
                                            <asp:ListItem Text="Maharashtra" Value="Maharashtra" />
                                            <asp:ListItem Text="Gujarat" Value="Gujarat" />
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="rfvState" runat="server" ControlToValidate="ddlState"
                                            InitialValue="" ErrorMessage="State is required" CssClass="text-danger" Display="Dynamic" ValidationGroup="EmpForm" />
                                    </div>
                                </div>

                                <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-success"
                                    OnClick="btnSubmit_Click" UseSubmitBehavior="false" ValidationGroup="EmpForm" />

                                <asp:Button ID="btnUpdate" runat="server" Text="Update" CssClass="btn btn-primary"
                                    OnClick="btnUpdate_Click" UseSubmitBehavior="false" ValidationGroup="EmpForm" Visible="false" />

                            </asp:Panel>
                        </div>
                    </div>
                </div>
            </div>

        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="txtDOB" EventName="TextChanged" />
            <asp:AsyncPostBackTrigger ControlID="btnSubmit" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>

    <style>
        .modal-backdrop {
            background-color: rgba(0, 0, 0, 0.3) !important;
        }

        gv-pager {
            margin-top: 15px;
            display: flex;
            justify-content: center;
        }

        /* Style each page number link */
        .gv-pager a, .gv-pager span {
            display: inline-block;
            padding: 6px 12px;
            margin: 2px;
            border: 1px solid #007bff;
            color: #007bff;
            text-decoration: none;
            border-radius: 4px;
            font-weight: 500;
            background-color: #fff;
        }

            /* Hover effect */
            .gv-pager a:hover {
                background-color: #007bff;
                color: white;
            }

        /* Active page number */
        .gv-pager span {
            background-color: #007bff;
            color: white;
            font-weight: bold;
            cursor: default;
        }

        .chkRow {
            cursor: pointer;
            margin-left: auto;
            margin-right: auto;
            display: block;
        }
    </style>
    <script type="text/javascript">
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
            // Clean up leftover backdrop and class
            document.body.classList.remove('modal-open');
            document.querySelectorAll('.modal-backdrop').forEach(function (bd) { bd.remove(); });

            // ✅ Check hidden field for modal trigger
            var shouldShowModal = document.getElementById('<%= hdnShowModal.ClientID %>').value;
            if (shouldShowModal === "true") {
                var modalEl = document.getElementById('employeeModal');
                var modal = new bootstrap.Modal(modalEl);
                modal.show();

                // Reset flag
                document.getElementById('<%= hdnShowModal.ClientID %>').value = "false";
            }
        });

        function toggleAllCheckboxes(headerCheckbox) {
            const checkboxes = document.querySelectorAll('.chkRow');
            checkboxes.forEach(function (cb) {
                cb.checked = headerCheckbox.checked;
            });
        }

        function clearEmployeeForm() {
            // Clear input values
            document.getElementById('<%= txtName.ClientID %>').value = '';
            document.getElementById('<%= txtDOB.ClientID %>').value = '';
            document.getElementById('<%= txtAge.ClientID %>').value = '';
            document.getElementById('<%= txtDesignation.ClientID %>').value = '';
            document.getElementById('<%= txtDOJ.ClientID %>').value = '';
            document.getElementById('<%= txtSalary.ClientID %>').value = '';
            document.getElementById('<%= ddlGender.ClientID %>').selectedIndex = 0;
            document.getElementById('<%= ddlState.ClientID %>').selectedIndex = 0;

            // Clear hidden field
            document.getElementById('<%= hdnEmployeeId.ClientID %>').value = '';

            // Show submit button and hide update button
            document.getElementById('btnSubmit').style.display = 'block';
            document.getElementById('btnUpdate').style.display = 'none';
        }
    </script>




</asp:Content>
