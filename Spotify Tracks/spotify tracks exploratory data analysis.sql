

select *
from spotify_tracks;

-- 1. Most popular artist in descending order
select artists, max(popularity) as Most_popular
from spotify_tracks
group by artists
order by most_popular desc;

-- 2. What are the types of genres?
select genre
from spotify_tracks
group by genre;

-- 3. What is the highest played and the shortest played in each genre?
select genre, max(duration_ms) as highest_played_ms, min(duration_ms) as shortest_played_ms
from spotify_tracks
group by genre;

-- 4. What is the avergae duration played of each artist?
select artists, avg(duration_ms) as average_duration_played_ms
from spotify_tracks
group by artists
order by average_duration_played_ms desc;

-- 5. Whats the most popular Artist from each genre?
SELECT genre, artists, popularity
FROM spotify_tracks st
WHERE popularity = (
    SELECT MAX(popularity)
    FROM spotify_tracks
    WHERE genre = st.genre
)
ORDER BY genre;

-- 6. Is explicit music more popular?
SELECT explicit, AVG(popularity) AS avg_popularity
FROM spotify_tracks
GROUP BY explicit;

-- 7. Rank artists from the acoustic genre based on popularity
SELECT artists, album, popularity,
       RANK() OVER (ORDER BY popularity DESC) AS popularity_rank
FROM spotify_tracks
WHERE genre = 'Acoustic'
ORDER BY popularity_rank;

-- 8. Name artists who have more than 1 song
SELECT artists, COUNT(*) AS song_count
FROM spotify_tracks
GROUP BY artists
HAVING COUNT(*) > 1
ORDER BY song_count DESC;

-- 9. List the songs that are more popular than the average in their genre, and rank them by popularity within each genre 
WITH GenreAvgPopularity AS (
    SELECT genre, AVG(popularity) AS avg_popularity
    FROM spotify_tracks st
    GROUP BY genre
)
SELECT 
    st.artists,
    st.album,
    st.genre,
    st.popularity,
    RANK() OVER (PARTITION BY st.genre ORDER BY st.popularity DESC) AS popularity_Rank
FROM spotify_tracks st
JOIN GenreAvgPopularity gvp ON st.genre = gvp.genre
WHERE st.popularity > gvp.avg_popularity  
ORDER BY st.genre, popularity_Rank;





