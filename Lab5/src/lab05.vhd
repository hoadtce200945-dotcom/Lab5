library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 

entity lab05 is 
    generic ( 
        G_LFSR_WIDTH       : positive := 22; 
        -- Board Xiaomeige ACG525 dùng Button Pull-Up (Active-Low).
        -- G_BOARD_ACTIVE_LOW = true khi nạp board thật; false khi chạy simulation.
        G_BOARD_ACTIVE_LOW : boolean  := true 
    ); 
    port ( 
        i_Clk      : in  std_logic; 
        i_Rst      : in  std_logic;  
        i_Switch_1 : in  std_logic;  
        i_Switch_2 : in  std_logic;  
        o_LED_1    : out std_logic;  
        o_LED_2    : out std_logic;  
        o_LED_3    : out std_logic;  
        o_LED_4    : out std_logic   
    ); 
end entity lab05; 

architecture RTL of lab05 is 
    signal w_Rst   : std_logic; 
    signal w_Key0  : std_logic; 
    signal w_Key1  : std_logic; 
    signal w_Data0 : std_logic; 
    signal w_Data1 : std_logic; 
    signal w_Data2 : std_logic; 
    signal w_Data3 : std_logic; 

    signal w_LFSR_Done   : std_logic; 
    signal w_LFSR_Data   : std_logic_vector(G_LFSR_WIDTH-1 downto 0); 
    signal r_LFSR_Toggle : std_logic := '0'; 
begin 

  
    GEN_HW_POLARITY : if G_BOARD_ACTIVE_LOW generate 
        w_Rst  <= not i_Rst;      
        w_Key0 <= not i_Switch_1; 
        w_Key1 <= not i_Switch_2; 

        o_LED_1 <= w_Data0;       
        o_LED_2 <= w_Data1;       
        o_LED_3 <= w_Data2;       
        o_LED_4 <= w_Data3;      
    end generate GEN_HW_POLARITY; 

    GEN_SIM_POLARITY : if not G_BOARD_ACTIVE_LOW generate 
        w_Rst   <= i_Rst; 
        w_Key0  <= i_Switch_1; 
        w_Key1  <= i_Switch_2; 
        o_LED_1 <= w_Data0; 
        o_LED_2 <= w_Data1; 
        o_LED_3 <= w_Data2; 
        o_LED_4 <= w_Data3; 
    end generate GEN_SIM_POLARITY; 

    LFSR_INST : entity work.lfsr_timer 
        generic map ( 
            G_WIDTH => G_LFSR_WIDTH 
        ) 
        port map ( 
            i_Clk       => i_Clk, 
            i_Rst       => w_Rst, 
            o_LFSR_Data => w_LFSR_Data, 
            o_LFSR_Done => w_LFSR_Done 
        ); 

    -
    process (i_Clk) 
    begin 
        if rising_edge(i_Clk) then 
            if w_Rst = '1' then 
                r_LFSR_Toggle <= '0'; 
            elsif w_LFSR_Done = '1' then 
                r_LFSR_Toggle <= not r_LFSR_Toggle; 
            end if; 
        end if; 
    end process; 

    
    DEMUX_INST : entity work.demux_1_to_4 
        port map ( 
            i_Data  => r_LFSR_Toggle, 
            i_Sel0  => w_Key0, 
            i_Sel1  => w_Key1, 
            o_Data0 => w_Data0, 
            o_Data1 => w_Data1, 
            o_Data2 => w_Data2, 
            o_Data3 => w_Data3 
        ); 

end architecture RTL; 
