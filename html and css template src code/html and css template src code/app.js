// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/9.11.0/firebase-app.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.11.0/firebase-analytics.js";
import { getFirestore ,collection, getDocs } from  "https://www.gstatic.com/firebasejs/9.11.0/firebase-firestore.js";


// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
    apiKey: "AIzaSyAPD2rLWY3Nvbs3cW19-SkCQ7NtfeIr_xk",
    authDomain: "jamia-2bcc1.firebaseapp.com",
    projectId: "jamia-2bcc1",
    storageBucket: "jamia-2bcc1.appspot.com",
    messagingSenderId: "585806474023",
    appId: "1:585806474023:web:e98bb5c8e5e1472f4c1702",
    measurementId: "G-45VRZZ51WF"
};


// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
// Initialize Cloud Firestore and get a reference to the service
const db = getFirestore(app);
const querySnapshot = await getDocs(collection(db, "users"));
querySnapshot.forEach((doc) => {
console.log(`${doc.id} => ${doc.data()}`);
});
// create element & render cafe
function renderCafe(doc){
    let li = document.createElement('li');
    let name = document.createElement('span');
    let city = document.createElement('span');
    let cross = document.createElement('div');

    li.setAttribute('data-id', doc.id);
    name.textContent = doc.data().name;
    city.textContent = doc.data().Email;

    li.appendChild(name);
    li.appendChild(city);
    li.appendChild(cross);

    cafeList.appendChild(li);
}

// Read data
db.collection('users').orderBy('Email').onSnapshot(snapshot => {
    let changes = snapshot.docChanges();
    changes.forEach(change => {
        console.log(change.doc.data());
        
            renderCafe(change.doc);
    });
});
