class GiveAllCompetitorsDefaultWins < ActiveRecord::Migration
  def change
    Competitor.all.each do |competitor|
      competitor.update_attributes({:wins => 0})
    end
  end
end
