import { initializeApp } from 'https://www.gstatic.com/firebasejs/13.4.0/firebase-app.js';
import { getAuth, onAuthStateChanged, signInWithEmailAndPassword, signOut } from 'https://www.gstatic.com/firebasejs/13.4.0/firebase-auth.js';
import { getFirestore, doc, getDoc, setDoc, collection, getDocs, addDoc, updateDoc, deleteDoc, query, orderBy } from 'https://www.gstatic.com/firebasejs/13.4.0/firebase-firestore.js';

const firebaseConfig = {
  apiKey: 'AIzaSyC8K47Eunn47fpTbbpGNOAd9W82x4KbirU',
  authDomain: 'tickethamsterv4.firebaseapp.com',
  projectId: 'tickethamsterv4',
  storageBucket: 'tickethamsterv4.firebasestorage.app',
  messagingSenderId: '1005415031406'
};

const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const db = getFirestore(app);

const $ = (s) => document.querySelector(s);
const login = $('#login'), shell = $('#app'), loginError = $('#loginError'), toast = $('#toast');
let tickets = [], discoverEvents = [], currentTicketId = null, currentDiscoverId = null;

function notify(msg){ toast.textContent=msg; toast.classList.add('show'); setTimeout(()=>toast.classList.remove('show'),2200); }
function esc(v=''){return String(v).replace(/[&<>'"]/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;',"'":'&#39;','"':'&quot;'}[c]));}
function fset(form,data){Object.entries(data||{}).forEach(([k,v])=>{const el=form.elements.namedItem(k);if(el)el.value=v??'';});}
function fdata(form){return Object.fromEntries([...new FormData(form).entries()].filter(([k])=>k!=='docId'));}

$('#loginForm').addEventListener('submit', async e=>{e.preventDefault();loginError.textContent='';try{await signInWithEmailAndPassword(auth,$('#email').value,$('#password').value);}catch(err){loginError.textContent='No se pudo iniciar sesión. Revisa email, contraseña y que Email/Password esté habilitado en Firebase Auth.';}});
$('#logoutBtn').addEventListener('click',()=>signOut(auth));

onAuthStateChanged(auth, async user=>{
  if(user){login.classList.add('hidden');shell.classList.remove('hidden');$('#userEmail').textContent=user.email||user.uid;await loadAll();}
  else{shell.classList.add('hidden');login.classList.remove('hidden');}
});

for(const b of document.querySelectorAll('.nav-item')) b.addEventListener('click',()=>{
  document.querySelectorAll('.nav-item').forEach(x=>x.classList.toggle('active',x===b));
  document.querySelectorAll('.section').forEach(s=>s.classList.remove('active-section'));
  $('#'+b.dataset.section).classList.add('active-section');
  $('#pageTitle').textContent=b.textContent;
});

async function loadAll(){await Promise.all([loadEvent(),loadTickets(),loadDiscover()]);renderDashboard();}
$('#refreshBtn').addEventListener('click',async()=>{await loadAll();notify('Datos actualizados');});

async function loadEvent(){const snap=await getDoc(doc(db,'Event','Evento'));const data=snap.exists()?snap.data():{};fset($('#eventForm'),data);const img=$('#eventPreview');if(data.eventIMG){img.src=data.eventIMG;img.style.display='block'}else img.style.display='none';$('#statEvent').textContent=data.Nombre||'Sin nombre';return data;}
$('#eventForm').eventIMG.addEventListener('input',e=>{const img=$('#eventPreview');img.src=e.target.value;img.style.display=e.target.value?'block':'none';});
$('#eventForm').addEventListener('submit',async e=>{e.preventDefault();await setDoc(doc(db,'Event','Evento'),fdata(e.currentTarget),{merge:true});notify('Evento guardado');await loadEvent();renderDashboard();});

async function loadTickets(){let snap;try{snap=await getDocs(query(collection(db,'Event','Evento','Tickets'),orderBy('Order')));}catch{snap=await getDocs(collection(db,'Event','Evento','Tickets'));}tickets=snap.docs.map(d=>({id:d.id,...d.data()})).sort((a,b)=>(+a.Order||0)-(+b.Order||0));$('#statTickets').textContent=tickets.length;renderTickets();}
function renderTickets(){const root=$('#ticketsList');root.innerHTML=tickets.length?tickets.map(t=>`<article class="data-card"><img src="${esc(t.ImageUrl||'')}" onerror="this.style.visibility='hidden'"><div><h4>${esc(t.Name||t.Type||'Boleto')}</h4><p>Sección ${esc(t.Sec||'—')} · Fila ${esc(t.Row||'—')} · Asiento ${esc(t.Seat||'—')}</p><div class="meta">Orden ${esc(t.Order??'—')} · ${esc(t.Date||'')}</div></div><button class="secondary edit-ticket" data-id="${esc(t.id)}">Editar</button></article>`).join(''):'<p>No hay boletos cargados.</p>';root.querySelectorAll('.edit-ticket').forEach(b=>b.addEventListener('click',()=>openTicket(b.dataset.id)));}
function openTicket(id){currentTicketId=id||null;const form=$('#ticketForm');form.reset();form.elements.docId.value=id||'';const t=tickets.find(x=>x.id===id);if(t)fset(form,t);else form.elements.Order.value=(Math.max(0,...tickets.map(x=>+x.Order||0))+1);$('#ticketModalTitle').textContent=id?'Editar boleto':'Nuevo boleto';$('#deleteTicketBtn').style.visibility=id?'visible':'hidden';$('#ticketDialog').showModal();}
$('#newTicketBtn').addEventListener('click',()=>openTicket(null));
$('#ticketForm').addEventListener('submit',async e=>{e.preventDefault();e.stopPropagation();const data=fdata(e.currentTarget);data.Order=Number(data.Order||0);if(currentTicketId)await updateDoc(doc(db,'Event','Evento','Tickets',currentTicketId),data);else await addDoc(collection(db,'Event','Evento','Tickets'),data);$('#ticketDialog').close();notify('Boleto guardado');await loadTickets();renderDashboard();});
$('#deleteTicketBtn').addEventListener('click',async()=>{if(!currentTicketId||!confirm('¿Eliminar este boleto?'))return;await deleteDoc(doc(db,'Event','Evento','Tickets',currentTicketId));$('#ticketDialog').close();notify('Boleto eliminado');await loadTickets();renderDashboard();});

async function loadDiscover(){const snap=await getDocs(collection(db,'Event','Discover','Eventos'));discoverEvents=snap.docs.map(d=>({id:d.id,...d.data()})).sort((a,b)=>(+a.id||999999)-(+b.id||999999));$('#statDiscover').textContent=discoverEvents.length;renderDiscover();}
function renderDiscover(){const root=$('#discoverList');root.innerHTML=discoverEvents.length?discoverEvents.map(e=>`<article class="data-card"><img src="${esc(e.EventoUrl||'')}" onerror="this.style.visibility='hidden'"><div><h4>${esc(e.Nombre||'Evento')}</h4><p>${esc(e.Lugar||'')}</p><div class="meta">Documento ${esc(e.id)} · ${esc(e.Fecha||'')}</div></div><button class="secondary edit-discover" data-id="${esc(e.id)}">Editar</button></article>`).join(''):'<p>No hay eventos en Inicio.</p>';root.querySelectorAll('.edit-discover').forEach(b=>b.addEventListener('click',()=>openDiscover(b.dataset.id)));}
function nextDiscoverId(){const nums=discoverEvents.map(e=>parseInt(e.id,10)).filter(Number.isFinite);return String((nums.length?Math.max(...nums):0)+1);}
function openDiscover(id){currentDiscoverId=id||null;const form=$('#discoverForm');form.reset();form.elements.docId.value=id||'';const e=discoverEvents.find(x=>x.id===id);if(e)fset(form,e);$('#discoverModalTitle').textContent=id?'Editar evento':'Nuevo evento';$('#deleteDiscoverBtn').style.visibility=id?'visible':'hidden';$('#discoverDialog').showModal();}
$('#newDiscoverBtn').addEventListener('click',()=>openDiscover(null));
$('#discoverForm').addEventListener('submit',async e=>{e.preventDefault();e.stopPropagation();const data=fdata(e.currentTarget);const id=currentDiscoverId||nextDiscoverId();await setDoc(doc(db,'Event','Discover','Eventos',id),data,{merge:true});$('#discoverDialog').close();notify('Evento de Inicio guardado');await loadDiscover();renderDashboard();});
$('#deleteDiscoverBtn').addEventListener('click',async()=>{if(!currentDiscoverId||!confirm('¿Eliminar este evento de Inicio?'))return;await deleteDoc(doc(db,'Event','Discover','Eventos',currentDiscoverId));$('#discoverDialog').close();notify('Evento eliminado');await loadDiscover();renderDashboard();});

document.querySelectorAll('[data-close]').forEach(b=>b.addEventListener('click',()=>$('#'+b.dataset.close).close()));
function renderDashboard(){const ev=Object.fromEntries(new FormData($('#eventForm')).entries());$('#dashboardSummary').innerHTML=`<div class="summary-row"><span>Evento principal</span><strong>${esc(ev.Nombre||'Sin nombre')}</strong></div><div class="summary-row"><span>Fecha</span><strong>${esc(ev.Fecha||'—')}</strong></div><div class="summary-row"><span>Lugar</span><strong>${esc(ev.Lugar||'—')}</strong></div><div class="summary-row"><span>Boletos asociados</span><strong>${tickets.length}</strong></div><div class="summary-row"><span>Eventos en Inicio</span><strong>${discoverEvents.length}</strong></div>`;}
