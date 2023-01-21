use anchor_lang::prelude::*;
use crate::pda::user::User;

mod pda;
mod ix;

declare_id!("CZCZcK4vGvNSikQCTeSfPFazkBGwVBN1c6AjpnwDWgzN");

#[program]
pub mod solana_elm {
    use super::*;

    pub fn increment(ctx: Context<Increment>) -> Result<()> {
        ix::increment::ix(ctx)
    }
}

#[derive(Accounts)]
pub struct Increment<'info> {
    // pda
    #[account(init_if_needed,
    seeds = [
    pda::user::SEED.as_bytes(),
    payer.key().as_ref()
    ], bump,
    payer = payer,
    space = pda::user::SIZE
    )]
    pub user: Account<'info, User>,
    // payer
    #[account(mut)]
    pub payer: Signer<'info>,
    // system
    pub system_program: Program<'info, System>,
}
