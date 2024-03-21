class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.string :phone

      t.timestamps
    end
  end
end

# docker-compose run --rm web rails generate migration ChangeColumnToBeStringInUser phone:string

