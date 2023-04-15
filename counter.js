
const api_url = "your api here";

var viewCount = parseInt(localStorage.getItem("viewCount")) || 0;
viewCount++;
localStorage.setItem("viewCount", viewCount);

fetch(api_url, {
method: "POST",
body: JSON.stringify({ count: viewCount }),
})
.then((response) => {
    return response.json();
})
.then((data) => {
    console.log("View count incremented to: " + data);
})
.catch((error) => {
    console.error("Error incrementing view count: ", error);
});

