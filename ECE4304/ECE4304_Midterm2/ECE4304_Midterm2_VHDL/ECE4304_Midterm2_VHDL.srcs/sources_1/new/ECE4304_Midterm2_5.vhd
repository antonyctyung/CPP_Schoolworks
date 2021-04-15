LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ECE4304_Midterm2_5 IS
    PORT (
        fsm_clk : IN STD_LOGIC;
        fsm_rst : IN STD_LOGIC;
        fsm_in : IN STD_LOGIC;
        fsm_out : OUT STD_LOGIC
    );
END ECE4304_Midterm2_5;

ARCHITECTURE Behavioral OF ECE4304_Midterm2_5 IS

    -- state definition
    TYPE state_type IS (
        s0,
        s1,
        s2,
        s3
    );

    -- state registers
    SIGNAL ps_state : state_type; -- present state register
    SIGNAL ns_state : state_type; -- next state register
    SIGNAL fsm_out_next : STD_LOGIC; -- next output

BEGIN

    -- state transition logic
    STATE_TRAN : PROCESS (fsm_clk, fsm_rst)
    BEGIN
        IF (fsm_rst = '1') THEN -- reset state
            ps_state <= s0;
        ELSIF (rising_edge(fsm_clk)) THEN
            ps_state <= ns_state; -- state transition
            fsm_out <= fsm_out_next; -- output transition
        END IF;
    END PROCESS;

    -- (asynchronous) next state logic
    STATE_NEXT : PROCESS (ps_state, fsm_in)
    BEGIN
        fsm_out_next <= '0';
        CASE ps_state IS
            WHEN s0 =>
                IF (fsm_in = '1') THEN
                    ns_state <= s1;
                ELSE
                    ns_state <= s0;
                END IF;
            WHEN s1 =>
                IF (fsm_in = '1') THEN
                    ns_state <= s1;
                ELSE
                    ns_state <= s2;
                END IF;
            WHEN s2 =>
                IF (fsm_in = '1') THEN
                    ns_state <= s0;
                ELSE
                    ns_state <= s3;
                END IF;
            WHEN s3 =>
                IF (fsm_in = '1') THEN
                    ns_state <= s1;
                ELSE
                    ns_state <= s0;
                    fsm_out_next <= '1';
                END IF;
            WHEN OTHERS =>
        END CASE;
    END PROCESS;

END Behavioral;