package org.hedgewars.hedgeroid;

import org.hedgewars.hedgeroid.R;
import org.hedgewars.hedgeroid.netplay.Netplay;

import android.os.Bundle;
import android.os.CountDownTimer;
import android.support.v4.app.ListFragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;

public class RoomlistFragment extends ListFragment implements OnItemClickListener {
	private static final int AUTO_REFRESH_INTERVAL_MS = 15000;
	
	private Netplay netplay;
	private RoomlistAdapter adapter;
	private CountDownTimer autoRefreshTimer = new CountDownTimer(Long.MAX_VALUE, AUTO_REFRESH_INTERVAL_MS) {
		@Override
		public void onTick(long millisUntilFinished) {
			netplay.sendRoomlistRequest();
		}
		
		@Override
		public void onFinish() { }
	};

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		netplay = Netplay.getAppInstance(getActivity().getApplicationContext());
		adapter = new RoomlistAdapter(getActivity());
		adapter.setSource(netplay.roomList);
		setListAdapter(adapter);
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		return inflater.inflate(R.layout.lobby_rooms_fragment, container, false);
	}
	
	@Override
	public void onActivityCreated(Bundle savedInstanceState) {
		super.onActivityCreated(savedInstanceState);
		getListView().setOnItemClickListener(this);
	}
	
	@Override
	public void onResume() {
		super.onResume();
		autoRefreshTimer.start();
	}
	
	@Override
	public void onPause() {
		super.onPause();
		autoRefreshTimer.cancel();
	}
	
	@Override
	public void onDestroy() {
		super.onDestroy();
		adapter.invalidate();
	}
	
	public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
		netplay.sendJoinRoom(adapter.getItem(position).room.name);
	}
}
