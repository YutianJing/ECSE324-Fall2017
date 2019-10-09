int main(){
		int a[5] = {1,20,3,4,5};
		int max_val;

		//int 1 = 0;
		max_val = a[0];
           int i;
	for(i = 0; i<5; i++){
		if(a[i+1] > max_val){
		max_val = a[i+1];
	}
		}

		return max_val;

}