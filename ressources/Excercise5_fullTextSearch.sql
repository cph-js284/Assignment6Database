select posts.Title, posts.OwnerUserId
from posts
where match (posts.Title)
against ('grounds' in boolean mode)

