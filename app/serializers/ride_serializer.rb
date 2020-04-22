class RideSerializer < ActiveModel::Serializer
  ActiveModelSerializers.config.adapter = :json
  attributes :id, :organization_id, :rider_id, :driver_id, :pick_up_time, :start_location, :end_location,  :reason, :status, :completed_at, :round_trip, :expected_wait_time,
  :pick_up_to_drop_off_distance, :pick_up_to_drop_off_time

end
