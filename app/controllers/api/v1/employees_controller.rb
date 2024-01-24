class Api::V1::EmployeesController < ApplicationController
  #GET  /employees
  #Limit add  for showing the pages scan cannot be used for retrieving all the data
  def index
    @employees = Crudop::Dynamo.scan_dynamodb_table("Employee")
    render json: @employees
  end
  
  #GET /employees/:id
  def show 
    key = "EMPNO" 
    value = params[:id].to_i
    begin
      @employee = Crudop::Dynamo.dy_query_item("Employee", key,value)
      render json: {status: 'SUCCESS', message: 'Saved employee', data: @employee}, status: :ok
    rescue Exception => e
      render json: {status: 'ERROR', message: 'Employee not saved', data: dynamo_item}, status: :unprocessable_entity
    end 
  end
  
  #POST /employees
  def create
    #Formatting the json data acording to dynamodb format
    dynamo_item = format_dynamo_params(em_params)
    begin
      @employee = Crudop::Dynamo.dy_put_item("Employee", dynamo_item)
      render json: {status: 'SUCCESS', message: 'Saved employee', data: dynamo_item}, status: :ok
    rescue Exception => e
      render json: {status: 'ERROR', message: 'Employee not saved', data: dynamo_item}, status: :unprocessable_entity
    end
  
  end

  #DELETE /employees/:id
  def destroy
    name = "EMPNO"
    value = params[:id].to_i
    key = {name => value}
    begin
      Crudop::Dynamo.dy_delete_item("Employee", key)
      render json: { status: 'SUCCESS', message: 'Deleted employee', id: value }, status: :ok
    rescue StandardError => e
      render json: { status: 'ERROR', message: 'Employee not deleted', error: e.message }, status: :unprocessable_entity
    end
  end
  

  
    
  
  private
  def em_params
    params.require(:employee).permit(:EMPNO, :FirstName, :LastName, :DOB, :HiredDate, :Salary, :Bonus, :WorkDept, :PhoneNo, :Job, :EDLevel, :Sex)
  end
  
  def format_dynamo_params(employee_params)
    dynamo_formatted = {}
    
    employee_params.each do |key, value|
    # DynamoDB requires specifying the data type for each attribute
      if key == "EMPNO"
        dynamo_formatted[key] = value.to_i
      else 
        dynamo_formatted[key] =  value.to_s 
      end
    end
    
    dynamo_formatted
  end
  
end