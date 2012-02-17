# == Schema Information
#
# Table name: game_snapshots
#
#  id                                      :integer(4)      not null, primary key
#  rank                                    :integer(4)
#  rating                                  :float
#  game_id                                 :integer(4)
#  meta_data_id                            :integer(4)
#  chart_snapshot_id                       :integer(4)
#  created_at                              :datetime
#  updated_at                              :datetime
#  average_user_rating_for_current_version :decimal(2, 1)
#  user_rating_count_for_current_version   :integer(4)
#  average_user_rating_for_all_versions    :decimal(2, 1)
#  user_rating_count_for_all_versions      :integer(4)
#  appstore_syncronized                    :boolean(1)      default(FALSE)
#  price                                   :decimal(5, 2)
#  currency                                :string(255)
#  itunes_id                               :integer(8)
#
# Indexes
#
#  index_game_snapshots_on_meta_data_id          (meta_data_id)
#  index_game_snapshots_on_game_id               (game_id)
#  index_game_snapshots_on_chart_snapshot_id     (chart_snapshot_id)
#  index_game_snapshots_on_appstore_syncronized  (appstore_syncronized)
#

require 'spec_helper'

describe GameSnapshot do
  
end

