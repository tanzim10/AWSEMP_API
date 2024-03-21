require 'rails_helper'

RSpec.describe User, type: :model do
    it "is valid with valid attributes" do
        user = User.new(
      first_name: "John",
      last_name: "Doe",
      email: "john.doe@example.com",
      password: "password123",
      password_confirmation: "password123",
      phone: "1234567890"
    )
        expect(user).to be_valid
    end

    it "is not valid without a first name" do
        user = User.new(
        first_name: "",
        last_name: "Doe",
        email: "john.doe@example.com",
        password: "password123",
        password_confirmation: "password123",
        phone: "1234567890"
        )
        expect(user).to_not be_valid
        expect(user.errors[:first_name]).to include("can't be blank")
    end

    it "is not valid without a last name" do
        user = User.new(
        first_name: "John",
        last_name: "",
        email: "john.doe@example.com",
        password: "password123",
        password_confirmation: "password123",
        phone: "1234567890"
        )
        expect(user).to_not be_valid
        expect(user.errors[:last_name]).to include("can't be blank")
    end
    
    it "is not valid without an email" do
        user = User.new(
        first_name: "John",
        last_name: "Doe",
        email: "",
        password: "password123",
        phone: "1234567890"
        )
        expect(user).to_not be_valid
        expect(user.errors[:email]).to include("can't be blank")
    end

    it "is not valid without a password" do
        user = User.new(
        first_name: "John",
        last_name: "Doe",
        email: "john.12@gmail.com",
        password: "",
        phone: "1234567890"
        )
        expect(user).to_not be_valid
        expect(user.errors[:password]).to include("can't be blank")
    end

    it "is not valid without a phone" do
        user = User.new(
            first_name: "John",
            last_name: "Doe",
            email: "john.12@gmail.com",
            password: "password123",
            phone: ""
            )
        expect(user).to_not be_valid
        expect(user.errors[:phone]).to include("can't be blank")
    end

    context "email validation" do
        it "is not valid with a wrong email format" do
            user = User.new(
            first_name: "John",
            last_name: "Doe",
            email: "johngmail.com",
            password: "password123",
            phone: "1234567890"
            )
            expect(user).to_not be_valid
            expect(user.errors[:email]).to include("Enter valid email.")
        end 

    end


        
end
