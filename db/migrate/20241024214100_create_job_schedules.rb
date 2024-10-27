class CreateJobSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :job_schedules do |t|
      t.references :user, null: false, foreign_key: true
      t.string :cron

      t.timestamps
    end
  end
end
