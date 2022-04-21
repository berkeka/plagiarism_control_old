class CreateUserGithubAuthTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :github_auth_tokens do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :access_token
      t.string :refresh_token
      t.datetime :valid_until

      t.timestamps
    end
  end
end
