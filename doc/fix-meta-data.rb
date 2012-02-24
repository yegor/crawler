%w(AU CA CH FR DE JP KR GB US).each do |country|
    MetaData.select("DISTINCT itunes_id").where("itunes_artwork_icon_url = ''").map(&:itunes_id).in_groups_of(350).each do |id|
         j = JSON.parse( open("http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsLookup?id=#{ id.compact.join(',') }&country=#{ country }").read )["results"]
         MetaData.transaction do
           j.each do |jj|
             MetaData.update_all "itunes_artwork_icon_url = '#{ jj["artworkUrl60"] }'", "itunes_id = #{ jj["trackId"] }"
           end
         end
         puts "+ 350"
    end
end
