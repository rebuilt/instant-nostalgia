ActiveStorage::Attachment.all.each { |attachment| attachment.purge }
Photo.all.each { |photo| photo.destroy }
