		// Import the functions you need from the SDKs you need
		import { initializeApp } from "https://www.gstatic.com/firebasejs/9.11.0/firebase-app.js";
		import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.11.0/firebase-analytics.js";
		import { getFirestore, collection, getDocs } from "https://www.gstatic.com/firebasejs/9.11.0/firebase-firestore.js";
		import { doc, updateDoc } from "https://www.gstatic.com/firebasejs/9.11.0/firebase-firestore.js";



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
        function myFunction(x) {
            var val = 1;
            var updates = {
                status: val
            }

            x.classList.toggle("fa-thumbs-down");

            if (x.classList.value == "fa fa-thumbs-up") {
                // doc.update({status : 1});
                updateDoc(doc, { "status": 1 });
                console.log(doc.data().status + "l1");
                x.classList.toggle("fa-thumbs-down");
            }

            else if (x.classList.value == "fa fa-thumbs-down") {
                console.log(x.classList.value + 2);

                x.classList.toggle("fa-thumbs-up");
                updateDoc(doc, { "status": 1 });

            }




        }
		querySnapshot.docs.forEach((doc) => {

			// console.log(`${doc.fname} `);
			var table = document.getElementById("t");
			var row = table.insertRow(1);
			var cell1 = row.insertCell(0);
			var cell2 = row.insertCell(1);
			var cell3 = row.insertCell(2);

			cell3.innerHTML = " " + doc.data().fname + " " + doc.data().lname;
			cell2.innerHTML = doc.data().Email;
			if (doc.data().status == 1) {

				cell1.innerHTML = '<i href="#editEmployeeModal" data-toggle="tooltip" title="Edit data-toggle="modal" onclick="myFunction(this)" class="fa fa-thumbs-down"></i>';
			} else {
				cell1.innerHTML = '<i href="#editEmployeeModal" data-toggle="tooltip" title="Edit data-toggle="modal" onclick="myFunction(this)" class="fa fa-thumbs-up"></i>';
			}


		});