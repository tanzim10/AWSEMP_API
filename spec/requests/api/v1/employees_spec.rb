require 'rails_helper'

RSpec.describe 'API::V1::Employees', type: :request do
  describe 'GET /emp/:id' do
    let(:employee_table) {'Employee'}
    let(:employee_key) {'EMPNO'}
    let(:employee_id) {"1"}
    let(:employee_data) do 
      {
        "EMPNO": employee_id,
        "FirstName": 'John', 
        "LastName": 'Doe', 
        "DOB": '2000-03-24', 
        "HiredDate": '2023-04-31', 
        "Salary": '50000', 
        "Bonus": '10000',
        "WorkDept": 'IMSS', 
        "PhoneNo": '9021331', 
        "Job": 'Software Developer', 
        "EDLevel": 'Graduate', 
        "Sex": 'Male', 
        "Email": 'john.331@gmail.com'
      }
    end

    before do
      allow(Crudop::Dynamo).to receive(:dy_query_item)
      .and_return(employee_data)
    end
    it 'returns employee' do
      get "/api/v1/emp/#{employee_id}"

      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(json_response).to eq({
        "status" => 'SUCCESS',
        "message" => 'Saved employee',
        "data" => {
          "EMPNO" => employee_id,
          "FirstName" => 'John',
          "LastName" => 'Doe',
          "DOB" => '2000-03-24',
          "HiredDate" => '2023-04-31',
          "Salary" => '50000',
          "Bonus" => '10000',
          "WorkDept" => 'IMSS',
          "PhoneNo" => '9021331',
          "Job" => 'Software Developer',
          "EDLevel" => 'Graduate',
          "Sex" => "Male",
          "Email" => "john.331@gmail.com"
        }
      })
    end


    context 'when the employees does not exist' do
      before do
        allow(Crudop::Dynamo).to receive(:dy_query_item)
        .and_raise(StandardError, 'Employee not found')
      end

      it 'returns an error ' do
        get "/api/v1/emp/3"

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_response).to include({
          "status" => 'ERROR',
          "message" => 'Employee not saved',
          "data" => nil

        })
      end
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) do
      {
        "EMPNO" => 1,
        "FirstName" => 'John',
        "LastName" => 'Doe',
        "DOB" => '2000-03-24',
        "HiredDate" => '2023-04-31',
        "Salary" => '50000',
        "Bonus" => '10000',
        "WorkDept" => 'IMSS',
        "PhoneNo" => '9021331',
        "Job" =>'Software Developer',
        "EDLevel" => 'Graduate',
        "Sex" => 'Male',
        "Email" => 'john.331@gmail.com'
      }
    end

    before do
      allow(Crudop::Dynamo).to receive(:dy_put_item)
      .and_return(valid_attributes)
    end

    context 'when the request is valid' do
      it 'creates a employee' do
        post '/api/v1/create_emp', params: { employee: valid_attributes }
        json_response = JSON.parse(response.body)

        expect(Crudop::Dynamo).to have_received(:dy_put_item)
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_response).to eq({
          'status' => 'SUCCESS',
          'message' => 'Saved employee',
          'data' => valid_attributes
        })
      end
    end

    context 'when the request is invalid' do

      before do
        allow(Crudop::Dynamo).to receive(:dy_put_item)
        .and_raise(StandardError, 'Employee not saved')
      end

      it 'returns an error' do
        post '/api/v1/create_emp', params: { employee: valid_attributes }
        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_response).to eq({
          'status' => 'ERROR',
          'message' => 'Employee not saved',
          'data' => valid_attributes
        })
      end
    end

  end

  describe 'DELETE #destroy' do
    let (:employee_data) do
      {
        "EMPNO": 1,
        "FirstName": 'John',
      }
    end

    before do
      allow(Crudop::Dynamo).to receive(:dy_delete_item)
      .and_return(employee_data)
    end

    it 'deletes the employee' do
      delete '/api/v1/destroy_emp/1'

      json_response = JSON.parse(response.body)

      expect(Crudop::Dynamo).to have_received(:dy_delete_item)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(json_response).to eq({
        'status' => 'SUCCESS',
        'message' => 'Deleted employee'
      })
    end

    context 'when the employee does not exist' do
      before do
        allow(Crudop::Dynamo).to receive(:dy_delete_item)
        .and_raise(StandardError, 'Employee not deleted')
      end

      it 'returns an error' do
        delete '/api/v1/destroy_emp/3'

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_response).to eq({
          'status' => 'ERROR',
          'message' => 'Employee not deleted',
          'error' => 'Employee not deleted'
        })
      end
    end
  end

  describe 'PATCH #update' do
    let (:employee_data) do
      {
        "EMPNO": 1,
        "FirstName": 'John',
      }
    end

    let(:update_params) do
      {
        "FirstName" => 'John',
        "LastName" => 'Doe',
        "DOB" => '2000-03-24',
        "HiredDate" => '2023-04-31',
        "Salary" => '50000',
        "Bonus" => '10000',
        "WorkDept" => 'IMSS',
        "PhoneNo" => '9021331',
        "Job" =>'Software Developer',
        "EDLevel" => 'Graduate',
        "Sex" => "Male",
        "Email" => "johndoe232@gmail.com"
      }
    end
    

    before do 
      allow(Crudop::Dynamo).to receive(:dy_update_item)
      .and_return(update_params)
    end

    it 'updates the employee' do
      patch '/api/v1/update_emp/1', params: { employee: update_params }

      json_response = JSON.parse(response.body)

      expect(Crudop::Dynamo).to have_received(:dy_update_item)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(json_response).to eq({
        'status' => 'SUCCESS',
        'message' => 'Updated employee',
        'data' => update_params
      })
    end
    context 'when the employee does not exist' do
      before do
        allow(Crudop::Dynamo).to receive(:dy_update_item)
        .and_raise(StandardError, 'Employee not updated')
      end

      it 'returns an error' do
        patch '/api/v1/update_emp/3', params: { employee: update_params }

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_response).to eq({
          'status' => 'ERROR',
          'message' => 'Employee not updated',
          'error' => 'Employee not updated'
        })
      end
    end
  end

  
    



end


