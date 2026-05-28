use tauri::Manager;
use tokio::net::TcpListener;
use tokio_tungstenite::accept_async;
use mdns_sd::{ServiceDaemon, ServiceInfo};
use std::net::SocketAddr;
use std::thread;

#[tauri::command]
fn greet(name: &str) -> String {
    format!("Hello, {}! You've been greeted from Rust!", name)
}

async fn start_ws_server() {
    let addr = "127.0.0.1:8080";
    let listener = TcpListener::bind(addr).await.expect("Failed to bind");
    
    // Register mDNS service
    let mdns = ServiceDaemon::new().expect("Failed to create mdns daemon");
    let service_info = ServiceInfo::new(
        "_bluebird._tcp.local.",
        "BluebirdWindows",
        "bluebird.local.",
        "127.0.0.1",
        8080,
        None,
    ).unwrap();
    mdns.register(service_info).expect("Failed to register mDNS");

    while let Ok((stream, _)) = listener.accept().await {
        tokio::spawn(async move {
            let ws_stream = accept_async(stream).await.expect("Error during handshake");
            // Handle WebSocket connection here according to schema
        });
    }
}

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_opener::init())
        .invoke_handler(tauri::generate_handler![greet])
        .setup(|app| {
            tauri::async_runtime::spawn(start_ws_server());
            Ok(())
        })
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
